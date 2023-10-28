// The content marketplace platform
program patreon.aleo {
    mapping account: address => u64;
    mapping content_info: u8 => ContentInfo;
    mapping next_id: bool => u8;

    struct ContentInfo {
        name: u64,
        author: address,
        quantity: u64,
        price: u64,
    }
    
    record Token {
        owner: address,
        amount: u64,
    }

    record Content {
        owner: address,
        content_id: u8,
        name: u64,
        author: address,
        content: u64, 
    }

    record Order {
        owner: address,
        content_id: u8,
        buyer: address,
        deposit_amount: u64,
    }
    
    // The function `mint_public` issues the specified token amount for the token receiver publicly on the network.
    transition mint_token_public(public receiver: address, public amount: u64) {
        return then finalize(receiver, amount);
    }

    finalize mint_token_public(public receiver: address, public amount: u64) {
        let receiver_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
        Mapping::set(account, receiver, receiver_amount + amount);
    }

    // The function `mint_private` initializes a new record with the specified amount of tokens for the receiver.
    transition mint_token_private(receiver: address, amount: u64) -> Token {
        return Token {
            owner: receiver,
            amount: amount,
        };
    }

    // Authors will use this to add content to sell
    transition add_content(name: u64, author: address, quantity: u64, price: u64) {
        return then finalize(name, author, quantity, price);
    }

    finalize add_content(name: u64, author: address, quantity: u64, price: u64) {
        let info: ContentInfo = ContentInfo {
            name,
            author,
            quantity,
            price
        };

        let key: u8 = Mapping::get_or_use(next_id, true, 0u8);
        Mapping::set(next_id, true, key + 1u8);
        Mapping::set(content_info, key, info);
    }

    transition make_order_private(payment: Token, content_id: u8, name: u64, author: address, deposit_amount: u64) -> (Token, Content, Order) {
        assert(payment.amount >= deposit_amount);
        let remainder: u64 = payment.amount - deposit_amount;

        let remaining_token: Token = Token {
            owner: self.caller,
            amount: remainder,
        };

        let temp_content: Content = Content {
            owner: author,
            content_id,
            name,
            author,
            content: 0u64, 
        };

        let new_order: Order = Order {
            owner: author,
            content_id,
            buyer: self.caller,
            deposit_amount,
        };

        return (remaining_token, temp_content, new_order) then finalize(content_id, name, author, deposit_amount);
    }

    finalize make_order_private(content_id: u8, name: u64, author: address, deposit_amount: u64) {
        let info: ContentInfo = Mapping::get(content_info, content_id);
        assert(info.quantity > 0u64);
        assert_eq(deposit_amount, info.price);
        assert_eq(name, info.name);
        assert_eq(author, info.author);

        let remaining: u64 = info.quantity - 1u64;
        let new_info: ContentInfo = ContentInfo {
            name: info.name,
            author: info.author,
            quantity: remaining,
            price: info.price,
        };
        Mapping::set(content_info, content_id, new_info);
    }

    transition fulfil_order_private(content: Content, order: Order, content_data: u64) -> (Token, Content) {
        let filled_content: Content = Content {
            owner: order.buyer,
            content_id: content.content_id,
            name: content.name,
            author: content.author,
            content: content_data, 
        };

        let payout: Token = Token{
            owner: content.author,
            amount: order.deposit_amount
        };

        return (payout, filled_content);
    }

    transition make_order_public(content_id: u8, name: u64, author: address, deposit_amount: u64) -> (Content, Order) {
        let temp_content: Content = Content {
            owner: author,
            content_id,
            name,
            author,
            content: 0u64, 
        };

        let new_order: Order = Order {
            owner: author,
            content_id,
            buyer: self.caller,
            deposit_amount,
        };

        return (temp_content, new_order) then finalize(content_id, name, author, deposit_amount);
    }

    finalize make_order_public(content_id: u8, name: u64, author: address, deposit_amount: u64) {
        let info: ContentInfo = Mapping::get(content_info, content_id);
        assert(info.quantity > 0u64);
        assert_eq(deposit_amount, info.price);
        assert_eq(name, info.name);
        assert_eq(author, info.author);

        let remaining: u64 = info.quantity - 1u64;
        let new_info: ContentInfo = ContentInfo {
            name: info.name,
            author: info.author,
            quantity: remaining,
            price: info.price,
        };
        Mapping::set(content_info, content_id, new_info);
    }

    transition fulfil_order_public(content: Content, order: Order, content_data: u64) -> (Content) {
        let filled_content: Content = Content {
            owner: order.buyer,
            content_id: content.content_id,
            name: content.name,
            author: content.author,
            content: content_data, 
        };


        return (filled_content) then finalize (order.buyer, content.author, order.deposit_amount);
    }

    finalize fulfil_order_public (public buyer: address, public author: address, public amount: u64) {
        // Make public payment
        let buyer_amount: u64 = Mapping::get_or_use(account, buyer, 0u64);
        Mapping::set(account, buyer, buyer_amount - amount);
        let author_amount: u64 = Mapping::get_or_use(account, author, 0u64);
        Mapping::set(account, author, author_amount + amount);
    }
}
