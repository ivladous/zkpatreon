program patreon.aleo;

struct ContentInfo:
    name as u64;
    author as address;
    quantity as u64;
    price as u64;

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

record Order:
    owner as address.private;
    content_id as u8.private;
    buyer as address.private;
    deposit as u64.private;


mapping content_info:
	key as u8.public;
	value as ContentInfo.public;


mapping next_id:
	key as boolean.public;
	value as u8.public;

function mint_token:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 into r2 as Token.record;
    output r2 as Token.record;


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
