create table customercontact
(
    contactid      serial
        primary key,
    caddressid     integer
        references customeraddress,
    ccontactnumber varchar(15)
);

alter table customercontact
    owner to postgres;

