create table inventory
(
    inventoryid serial
        primary key,
    itemcode    integer not null
        references item,
    itemuomid   integer not null
        references itemuom,
    itemstock   integer
);

alter table inventory
    owner to postgres;

