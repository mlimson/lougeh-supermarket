create table deliveryline
(
    dlineid        serial
        primary key,
    dtransactionid integer
        references deliverytransaction,
    inventoryid    integer
        references inventory,
    itemcode       integer
        references item,
    dqty           integer,
    itemcost       numeric(10, 2)
);

alter table deliveryline
    owner to postgres;

