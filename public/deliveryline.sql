create table deliveryline
(
    dlineid        serial
        primary key,
    dtransactionid integer not null
        references deliverytransaction,
    inventoryid    integer not null
        references inventory,
    itemcode       integer not null
        references item,
    dqty           integer not null,
    itemcost       numeric(10, 2)
);

alter table deliveryline
    owner to postgres;

create index idx_dtransactionid
    on deliveryline (dtransactionid);

create index idx_dlitemcode
    on deliveryline (itemcode);

