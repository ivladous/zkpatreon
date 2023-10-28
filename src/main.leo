import token.leo;

// The content marketplace platform
program patreon.aleo {
    mapping content_info: u8 => ContentInfo;
    mapping next_id: bool => u8;

    struct ContentInfo {
        name: u64,
        author: address,
        quantity: u64,
        price: u64,
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

    // Helper functions. Please ignore
    transition mint_token_public(receiver: address, amount: u64) {
        token.leo/mint_public(receiver, amount);
    }

    transition mint_token_private(receiver: address, amount: u64) -> (token.leo/token.record) {
        let new_token: token = token.leo/mint_private(receiver, amount);
        return (new_token);
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

    transition make_order_private(payment: token.leo/token.record, content_id: u8, name: u64, author: address, deposit_amount: u64) -> (token.leo/token.record, Content, Order) {
        assert(payment.amount >= deposit_amount);
        let remainder: u64 = payment.amount - deposit_amount;
        let remaining_token: token = token.leo/mint_private(self.caller, remainder);

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

        return (remaining_token, temp_content, new_order) then finalize(content_id, name, author, self.caller, deposit_amount);
    }

    finalize make_order_private(content_id: u8, name: u64, author: address, buyer: address, deposit_amount: u64) {
        let info: ContentInfo = Mapping::get(content_info, content_id);
        assert(info.quantity > 0u64);
        assert(deposit_amount > info.price);

        let remaining: u64 = info.quantity - 1u64;
        let new_info: ContentInfo = ContentInfo {
            name: info.name,
            author: info.author,
            quantity: remaining,
            price: info.price,
        };
        Mapping::set(content_info, content_id, new_info);
    }

    transition fulfil_order_private(content: Content, order: Order, content_data: u64) -> (token.leo/token.record, Content) {
        let temp_content: Content = Content {
            owner: order.buyer,
            content_id: content.content_id,
            name: content.name,
            author: content.author,
            content: content_data, 
        };

        let payout: token = token.leo/mint_private(content.author, order.deposit_amount);

        return (payout, temp_content);
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

        return (temp_content, new_order) then finalize(content_id, name, author, self.caller, deposit_amount);
    }

    finalize make_order_public(content_id: u8, name: u64, author: address, buyer: address, deposit_amount: u64) {
        let info: ContentInfo = Mapping::get(content_info, content_id);
        assert(info.quantity > 0u64);
        assert(deposit_amount > info.price);

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
        let temp_content: Content = Content {
            owner: order.buyer,
            content_id: content.content_id,
            name: content.name,
            author: content.author,
            content: content_data, 
        };

        // Make payment. Logic & checks are handled by the token program
        token.leo/transfer_public_from(order.buyer, content.author, order.deposit_amount);

        return (temp_content);
    }
}
