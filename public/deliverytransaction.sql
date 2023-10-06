create table deliverytransaction
(
    dtransactionid serial
        primary key,
    suppliercode   integer not null
        references suppliers,
    timestamp      timestamp
);

alter table deliverytransaction
    owner to postgres;

create index idx_suppliercode
    on deliverytransaction (suppliercode);

