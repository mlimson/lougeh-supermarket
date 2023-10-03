create table deliverytransaction
(
    dtransactionid serial
        primary key,
    suppliercode   integer
        references suppliers,
    timestamp      timestamp
);

alter table deliverytransaction
    owner to postgres;

