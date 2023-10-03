create table suppliercontact
(
    scontactid    serial
        primary key,
    saddressid    integer
        references supplieraddress,
    contactnumber varchar(15)
);

alter table suppliercontact
    owner to postgres;

