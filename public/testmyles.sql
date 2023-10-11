create table testmyles
(
    testcolumnpk serial
        primary key,
    testdesc     varchar(255)
);

alter table testmyles
    owner to postgres;

