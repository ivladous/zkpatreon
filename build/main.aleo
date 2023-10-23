program patreon.aleo;

struct ItemInfo:
    name as u64;
    author as u64;
    quantity as u64;
    price as u64;

record Token:
    owner as address.private;
    amount as u64.private;

record Item:
    owner as address.private;
    item_id as u8.private;
    author as address.private;
    url as u64.private;

record Order:
    owner as address.private;
    item_id as u8.private;
    buyer as address.private;
    deposit_amount as u64.private;


mapping item_info:
	key as u8.public;
	value as ItemInfo.public;

function mint_token:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 into r2 as Token.record;
    output r2 as Token.record;


function add_item:
    input r0 as u8.private;
    input r1 as u64.private;
    cast self.caller r0 self.caller r1 into r2 as Item.record;
    output r2 as Item.record;


function make_order:
    input r0 as Token.record;
    input r1 as u8.private;
    input r2 as address.private;
    input r3 as u64.private;
    sub r0.amount r3 into r4;
    cast self.caller r4 into r5 as Token.record;
    cast r2 r1 self.caller r3 into r6 as Order.record;
    output r5 as Token.record;
    output r6 as Order.record;


function transfer_item:
    input r0 as Order.record;
    input r1 as Item.record;
    assert.eq r0.item_id r1.item_id;
    cast r0.buyer r1.item_id r1.author r1.url into r2 as Item.record;
    cast r0.owner r0.deposit_amount into r3 as Token.record;
    output r2 as Item.record;
    output r3 as Token.record;
