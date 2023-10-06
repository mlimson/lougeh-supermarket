create table salesline
(
    slineid        serial
        primary key,
    stransactionid integer not null
        references salestransaction,
    inventoryid    integer not null
        references inventory,
    itemcode       integer not null
        references item,
    sqty           integer not null,
    saleprice      numeric(10, 2)
);

alter table salesline
    owner to postgres;

create index idx_stransactionid
    on salesline (stransactionid);

create index idx_slitemcode
    on salesline (itemcode);

