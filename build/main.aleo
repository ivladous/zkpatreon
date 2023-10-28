import token.aleo;
program patreon.aleo;

<<<<<<< HEAD

=======
>>>>>>> master
struct ContentInfo:
    name as u64;
    author as address;
    quantity as u64;
    price as u64;

<<<<<<< HEAD
record Content:
    owner as address.private;
    content_id as u8.private;
    name as u64.private;
    author as address.private;
    content as u64.private;
=======
struct OrderInfo:
    content_id as u8;
    author as address;
    deposit as u64;

record Token:
    owner as address.private;
    amount as u64.private;

record Content:
    owner as address.private;
    content_id as u8.private;
    url as u64.private;
>>>>>>> master

record Order:
    owner as address.private;
    content_id as u8.private;
    buyer as address.private;
    deposit as u64.private;


mapping content_info:
	key as u8.public;
	value as ContentInfo.public;
<<<<<<< HEAD
=======


mapping next_id:
	key as boolean.public;
	value as u8.public;
>>>>>>> master


mapping next_id:
	key as boolean.public;
	value as u8.public;

function mint_token_public:
    input r0 as address.private;
    input r1 as u64.private;
    call token.aleo/mint_public r0 r1 into r2;
    async mint_token_public r2 into r3;
    output r3 as patreon.aleo/mint_token_public.future;

finalize mint_token_public:
    input r0 as token.aleo/mint_public.future;
    await r0;


<<<<<<< HEAD
function mint_token_private:
    input r0 as address.private;
    input r1 as u64.private;
    call token.aleo/mint_private r0 r1 into r2;
    output r2 as token.aleo/token.record;


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
    input r0 as token.aleo/token.record;
    input r1 as u8.private;
    input r2 as u64.private;
    input r3 as address.private;
    input r4 as u64.private;
    gte r0.amount r4 into r5;
    assert.eq r5 true;
    sub r0.amount r4 into r6;
    call token.aleo/mint_private self.caller r6 into r7;
    cast r3 r1 r2 r3 0u64 into r8 as Content.record;
    cast r3 r1 self.caller r4 into r9 as Order.record;
    async make_order_private r1 r2 r3 self.caller r4 into r10;
    output r7 as token.aleo/token.record;
    output r8 as Content.record;
    output r9 as Order.record;
    output r10 as patreon.aleo/make_order_private.future;

finalize make_order_private:
    input r0 as u8.public;
    input r1 as u64.public;
    input r2 as address.public;
    input r3 as address.public;
    input r4 as u64.public;
    get content_info[r0] into r5;
    gt r5.quantity 0u64 into r6;
    assert.eq r6 true;
    gt r4 r5.price into r7;
    assert.eq r7 true;
    sub r5.quantity 1u64 into r8;
    cast r5.name r5.author r8 r5.price into r9 as ContentInfo;
    set r9 into content_info[r0];


function fulfil_order_private:
    input r0 as Content.record;
    input r1 as Order.record;
    input r2 as u64.private;
    cast r1.buyer r0.content_id r0.name r0.author r2 into r3 as Content.record;
    call token.aleo/mint_private r0.author r1.deposit_amount into r4;
    output r4 as token.aleo/token.record;
    output r3 as Content.record;


function make_order_public:
    input r0 as u8.private;
    input r1 as u64.private;
    input r2 as address.private;
    input r3 as u64.private;
    cast r2 r0 r1 r2 0u64 into r4 as Content.record;
    cast r2 r0 self.caller r3 into r5 as Order.record;
    async make_order_public r0 r1 r2 self.caller r3 into r6;
    output r4 as Content.record;
    output r5 as Order.record;
    output r6 as patreon.aleo/make_order_public.future;

finalize make_order_public:
    input r0 as u8.public;
    input r1 as u64.public;
    input r2 as address.public;
    input r3 as address.public;
    input r4 as u64.public;
    get content_info[r0] into r5;
    gt r5.quantity 0u64 into r6;
    assert.eq r6 true;
    gt r4 r5.price into r7;
    assert.eq r7 true;
    sub r5.quantity 1u64 into r8;
    cast r5.name r5.author r8 r5.price into r9 as ContentInfo;
    set r9 into content_info[r0];


function fulfil_order_public:
    input r0 as Content.record;
    input r1 as Order.record;
    input r2 as u64.private;
    cast r1.buyer r0.content_id r0.name r0.author r2 into r3 as Content.record;
    call token.aleo/transfer_public_from r1.buyer r0.author r1.deposit_amount into r4;
    async fulfil_order_public r4 into r5;
    output r3 as Content.record;
    output r5 as patreon.aleo/fulfil_order_public.future;

finalize fulfil_order_public:
    input r0 as token.aleo/transfer_public_from.future;
    await r0;
=======
function add_content_info:
    input r0 as u64.public;
    input r1 as u64.public;
    input r2 as u64.public;
    async add_content_info self.caller r0 r1 r2 into r3;
    output r3 as patreon.aleo/add_content_info.future;

finalize add_content_info:
    input r0 as address.public;
    input r1 as u64.public;
    input r2 as u64.public;
    input r3 as u64.public;
    get next_id[true] into r4;
    cast r1 r0 r2 r3 into r5 as ContentInfo;
    set r5 into content_info[r4];
    add r4 1u8 into r6;
    set r6 into next_id[true];


function make_order:
    input r0 as Token.record;
    input r1 as OrderInfo.private;
    sub r0.amount r1.deposit into r2;
    cast self.caller r2 into r3 as Token.record;
    cast r1.author r1.content_id self.caller r1.deposit into r4 as Order.record;
    async make_order r1 into r5;
    output r3 as Token.record;
    output r4 as Order.record;
    output r5 as patreon.aleo/make_order.future;

finalize make_order:
    input r0 as OrderInfo.public;
    get content_info[r0.content_id] into r1;
    assert.eq r1.author r0.author;
    assert.eq r1.price r0.deposit;


function release_content:
    input r0 as Order.record;
    input r1 as u64.private;
    cast r0.buyer r0.content_id r1 into r2 as Content.record;
    cast r0.owner r0.deposit into r3 as Token.record;
    async release_content r0.content_id into r4;
    output r2 as Content.record;
    output r3 as Token.record;
    output r4 as patreon.aleo/release_content.future;

finalize release_content:
    input r0 as u8.public;
    get content_info[r0] into r1;
    sub r1.quantity 1u64 into r2;
    cast r1.name r1.author r2 r1.price into r3 as ContentInfo;
    set r3 into content_info[r0];


function init:
    assert.eq self.caller aleo1r57pmay8uaf03rkgsjmgnsazycwlmf5j6ztuxwgvdwthqpljgsyquz66kc;
    async init into r0;
    output r0 as patreon.aleo/init.future;

finalize init:
    set 0u8 into next_id[true];
>>>>>>> master
