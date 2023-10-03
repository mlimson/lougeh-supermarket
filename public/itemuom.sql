create table itemuom
(
    uniqueid serial
        primary key,
    itemcode integer
        references item,
    uomid    integer
        references uom
);

alter table itemuom
    owner to postgres;

