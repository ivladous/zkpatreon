import token.leo;

// The content marketplace platform
program patreon.aleo {
    mapping content_info: u64 => ContentInfo;

    struct ContentInfo {
        name: u64,
        author: address,
        quantity: u64,
        price: u64,
    }

    record Content {
        owner: address,
        content_id: u64,
        name: u64,
        author: address,
        content: u64, 
    }

    record Order {
        owner: address,
        content_id: u64,
        buyer: address,
        deposit_amount: u64,
    }

    // Helper functions. Please ignore
    transition mint_token(receiver: address, amount: u64) {
        token.leo/mint_public(receiver, amount);
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

        let key: u64 = BHP256::hash_to_u64(name + author);
        Mapping::set(content_info, key, info);
    }

    transition fulfil_order(content: Content, order: Order, content_info: u64) -> (Content) {
        let temp_content: Content = Content {
            owner: order.buyer,
            content_id: content.content_id,
            name: content.name,
            author: content.author,
            content: content_info, 
        };

        return (temp_content) then finalize(content.content_id, content.author, self.caller);
    }

    finalize fulfil_order(content_id: u64, author: address, buyer: address) {
        let info: ContentInfo = Mapping::get(content_info, content_id);
        assert(Mapping::get(token.leo/account, buyer) >= info.price);
        token.leo/transfer_public_from(buyer, author, info.price);
    }

    transition make_order(content_id: u64, name: u64, author: address, deposit_amount: u64) -> (Content, Order) {
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

    finalize make_order(content_id: u64, name: u64, author: address, buyer: address, deposit_amount: u64) {
        let info: ContentInfo = Mapping::get(content_info, content_id);
        assert(info.quantity > 0u64);
        assert(deposit_amount > info.price);
        // assert(Mapping::get(token.leo/account, buyer) >= deposit_amount);

        let remaining: u64 = info.quantity - 1u64;
        let new_info = {
            name: info.name,
            author: info.author,
            quantity: remaining,
            price:info.price,
        };
        Mapping::set(content_info, content_id, info);
    }
}
}
