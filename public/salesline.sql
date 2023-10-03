create table salesline
(
    slineid        serial
        primary key,
    stransactionid integer
        references salestransaction,
    inventoryid    integer
        references inventory,
    itemcode       integer
        references item,
    sqty           integer,
    saleprice      numeric(10, 2)
);

alter table salesline
    owner to postgres;

