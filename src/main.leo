// The 'patreon' program.
program patreon.aleo {

    mapping content_info: u8 => ContentInfo;
    mapping next_id: bool => u8;

    struct ContentInfo {
        name: u64,
        author: address,
        quantity: u64,
        price: u64,
    }

    struct OrderInfo {
        content_id: u8,
        author: address,
        deposit: u64,
    }

    record Token {
        owner: address,
        amount: u64,
    }

    record Content {
        owner: address,
        content_id: u8,
        url: u64, 
    }

    record Order {
        owner: address,
        content_id: u8,
        buyer: address,
        deposit: u64,
    }

    transition mint_token (receiver: address, amount: u64) -> Token {
        // assert_eq(self.caller, aleo1r57pmay8uaf03rkgsjmgnsazycwlmf5j6ztuxwgvdwthqpljgsyquz66kc);
        return Token {
            owner: receiver,
            amount: amount,
        };
    }

    transition add_content_info (public name: u64, public quantity: u64, public price: u64) {
        return then finalize(self.caller, name, quantity, price);
    }
    finalize add_content_info (
        public caller: address,
        public name: u64, 
        public quantity: u64, 
        public price: u64,
        ) {
        let c_id: u8 = Mapping::get(next_id, true);
        let c_info: ContentInfo = ContentInfo {
            name: name,
            author: caller,
            quantity: quantity,
            price: price,
        };
        Mapping::set(content_info, c_id, c_info);
        Mapping::set(next_id, true, c_id + 1u8);
    }

    transition make_order (token: Token, order_info: OrderInfo) -> (Token, Order) {
        let difference: u64 = token.amount - order_info.deposit;
        let remaining: Token = Token {
            owner: self.caller,
            amount: difference,
        };
        let new_order: Order = Order {
            owner: order_info.author,
            content_id: order_info.content_id,
            buyer: self.caller,
            deposit: order_info.deposit,

        };
        return (remaining, new_order) then finalize (order_info);
    }

    finalize make_order (order_info: OrderInfo) {
        let c_info: ContentInfo = Mapping::get(content_info, order_info.content_id);
        assert_eq(c_info.author, order_info.author);
        assert_eq(c_info.price, order_info.deposit);
    }

    transition release_content (order: Order, url: u64) -> (Content, Token) {
        let released_content: Content = Content {
            owner: order.buyer,
            content_id: order.content_id,
            url: url,
        };
        let payback: Token = Token {
            owner: order.owner,
            amount: order.deposit,
        };
        return (released_content, payback) then finalize(order.content_id);
    }
    finalize release_content (c_id: u8) {
        let c_info: ContentInfo = Mapping::get(content_info, c_id);
        let updated_info: ContentInfo = ContentInfo {
            name: c_info.name,
            author: c_info.author,
            quantity: c_info.quantity - 1u64,
            price: c_info.price,
        };
        Mapping::set(content_info, c_id, updated_info);
    }

    transition init () {
        assert_eq(self.caller, aleo1r57pmay8uaf03rkgsjmgnsazycwlmf5j6ztuxwgvdwthqpljgsyquz66kc);
        return then finalize ();
    }
    finalize init () {
        Mapping::set(next_id, true, 0u8);
    }
}
