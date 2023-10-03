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
    sqty           integer
);

alter table salesline
    owner to postgres;

