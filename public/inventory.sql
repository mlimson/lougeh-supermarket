create table inventory
(
    inventoryid serial
        primary key,
    itemcode    integer
        references item,
    itemuomid   integer
        references itemuom,
    itemstock   integer
);

alter table inventory
    owner to postgres;

