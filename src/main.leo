// The 'patreon' program.
program patreon.aleo {

    // mapping author_name: address => u64;
    // mapping item_quantity: u8 => u64;
    mapping item_info: u8 => ItemInfo;

    struct ItemInfo {
        name: u64,
        author: u64,
        quantity: u64,
        price: u64,
    }

    record Token {
        owner: address,
        amount: u64,
    }

    record Item {
        owner: address,
        item_id: u8,
        author: address,
        url: u64, 
    }

    record Order {
        owner: address,
        item_id: u8,
        buyer: address,
        deposit_amount: u64,
    }

    transition mint_token (receiver: address, amount: u64) -> Token {
        // assert_eq(self.caller, aleo1r57pmay8uaf03rkgsjmgnsazycwlmf5j6ztuxwgvdwthqpljgsyquz66kc);
        return Token {
            owner: receiver,
            amount: amount,
        };
    }

    transition add_item (item_id: u8, url: u64) -> Item {
        let new_item: Item = Item {
            owner: self.caller,
            item_id: item_id,
            author: self.caller,
            url: url,
        };
        return new_item;
    }

    transition make_order (token: Token, item_id: u8, author: address, deposit_amount: u64) -> (Token, Order) {
        let difference: u64 = token.amount - deposit_amount;
        let remaining: Token = Token {
            owner: self.caller,
            amount: difference,
        };
        let new_order: Order = Order {
            owner: author,
            item_id: item_id,
            buyer: self.caller,
            deposit_amount: deposit_amount,

        };
        return (remaining, new_order);
    }

    transition transfer_item (order: Order, item: Item) -> (Item, Token) {
        assert_eq(order.item_id, item.item_id);
        let transferred_item: Item = Item {
            owner: order.buyer,
            item_id: item.item_id,
            author: item.author,
            url: item.url,
        };
        let payback: Token = Token {
            owner: order.owner,
            amount: order.deposit_amount,
        };
        return (transferred_item, payback);
    }
}
