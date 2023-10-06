create table suppliercontact
(
    scontactid    serial
        primary key,
    saddressid    integer not null
        references supplieraddress,
    contactnumber varchar(15)
);

alter table suppliercontact
    owner to postgres;

