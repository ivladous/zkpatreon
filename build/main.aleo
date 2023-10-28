program patreon.aleo;

struct ContentInfo:
    name as u64;
    author as address;
    quantity as u64;
    price as u64;

record Token:
    owner as address.private;
    amount as u64.private;

record Content:
    owner as address.private;
    content_id as u8.private;
    name as u64.private;
    author as address.private;
    content as u64.private;

record Order:
    owner as address.private;
    content_id as u8.private;
    buyer as address.private;
    deposit_amount as u64.private;


mapping account:
	key as address.public;
	value as u64.public;


mapping content_info:
	key as u8.public;
	value as ContentInfo.public;


mapping next_id:
	key as boolean.public;
	value as u8.public;

function mint_token_public:
    input r0 as address.public;
    input r1 as u64.public;
    async mint_token_public r0 r1 into r2;
    output r2 as patreon.aleo/mint_token_public.future;

finalize mint_token_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];


function mint_token_private:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 into r2 as Token.record;
    output r2 as Token.record;


function add_content:
    input r0 as u64.private;
    input r1 as address.private;
    input r2 as u64.private;
    input r3 as u64.private;
    async add_content r0 r1 r2 r3 into r4;
    output r4 as patreon.aleo/add_content.future;

finalize add_content:
    input r0 as u64.public;
    input r1 as address.public;
    input r2 as u64.public;
    input r3 as u64.public;
    cast r0 r1 r2 r3 into r4 as ContentInfo;
    get.or_use next_id[true] 0u8 into r5;
    add r5 1u8 into r6;
    set r6 into next_id[true];
    set r4 into content_info[r5];


function make_order_private:
    input r0 as Token.record;
    input r1 as u8.private;
    input r2 as u64.private;
    input r3 as address.private;
    input r4 as u64.private;
    gte r0.amount r4 into r5;
    assert.eq r5 true;
    sub r0.amount r4 into r6;
    cast self.caller r6 into r7 as Token.record;
    cast r3 r1 r2 r3 0u64 into r8 as Content.record;
    cast r3 r1 self.caller r4 into r9 as Order.record;
    async make_order_private r1 r4 into r10;
    output r7 as Token.record;
    output r8 as Content.record;
    output r9 as Order.record;
    output r10 as patreon.aleo/make_order_private.future;

finalize make_order_private:
    input r0 as u8.public;
    input r1 as u64.public;
    get content_info[r0] into r2;
    gt r2.quantity 0u64 into r3;
    assert.eq r3 true;
    assert.eq r1 r2.price;
    sub r2.quantity 1u64 into r4;
    cast r2.name r2.author r4 r2.price into r5 as ContentInfo;
    set r5 into content_info[r0];


function fulfil_order_private:
    input r0 as Content.record;
    input r1 as Order.record;
    input r2 as u64.private;
    cast r1.buyer r0.content_id r0.name r0.author r2 into r3 as Content.record;
    cast r0.author r1.deposit_amount into r4 as Token.record;
    output r4 as Token.record;
    output r3 as Content.record;


function make_order_public:
    input r0 as u8.private;
    input r1 as u64.private;
    input r2 as address.private;
    input r3 as u64.private;
    cast r2 r0 r1 r2 0u64 into r4 as Content.record;
    cast r2 r0 self.caller r3 into r5 as Order.record;
    async make_order_public r0 r3 into r6;
    output r4 as Content.record;
    output r5 as Order.record;
    output r6 as patreon.aleo/make_order_public.future;

finalize make_order_public:
    input r0 as u8.public;
    input r1 as u64.public;
    get content_info[r0] into r2;
    gt r2.quantity 0u64 into r3;
    assert.eq r3 true;
    assert.eq r1 r2.price;
    sub r2.quantity 1u64 into r4;
    cast r2.name r2.author r4 r2.price into r5 as ContentInfo;
    set r5 into content_info[r0];


function fulfil_order_public:
    input r0 as Content.record;
    input r1 as Order.record;
    input r2 as u64.private;
    cast r1.buyer r0.content_id r0.name r0.author r2 into r3 as Content.record;
    async fulfil_order_public r1.buyer r0.author r1.deposit_amount into r4;
    output r3 as Content.record;
    output r4 as patreon.aleo/fulfil_order_public.future;

finalize fulfil_order_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    get.or_use account[r0] 0u64 into r3;
    sub r3 r2 into r4;
    set r4 into account[r0];
    get.or_use account[r1] 0u64 into r5;
    add r5 r2 into r6;
    set r6 into account[r1];
