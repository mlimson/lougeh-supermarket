create table customers
(
    customercode serial
        primary key,
    firstname    varchar(255) not null,
    lastname     varchar(255) not null,
    timestamp    timestamp
);

alter table customers
    owner to postgres;

