create procedure deleteitem(INOUT itmcode integer)
    language plpgsql
as
$$
    BEGIN
        DELETE FROM itemuom WHERE itemcode = itmCode;
        DELETE FROM item WHERE itemcode = itmCode;
        COMMIT;
    END
$$;

alter procedure deleteitem(inout integer) owner to postgres;

