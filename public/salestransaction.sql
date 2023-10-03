create table salestransaction
(
    stransactionid serial
        primary key,
    customercode   integer
        references customers,
    timestamp      timestamp
);

alter table salestransaction
    owner to postgres;

