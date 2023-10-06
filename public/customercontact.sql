create table customercontact
(
    contactid      serial
        primary key,
    caddressid     integer not null
        references customeraddress,
    ccontactnumber varchar(15)
);

alter table customercontact
    owner to postgres;

