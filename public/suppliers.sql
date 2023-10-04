create table suppliers
(
    suppliercode serial
        primary key,
    companyname  varchar(255),
    timestamp    timestamp
);

alter table suppliers
    owner to postgres;

create index idx_companyname
    on suppliers (companyname);

