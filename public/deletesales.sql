create procedure deletesales(INOUT stransid integer, IN itmcode integer DEFAULT 0, IN qty integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        IF EXISTS (SELECT stransactionid FROM salestransaction WHERE stransactionid = sTransId)
            THEN
                qty = (SELECT sqty FROM salesline WHERE stransactionid = sTransId);
                itmCode = (SELECT itemcode FROM salesline WHERE stransactionid = sTransId);
                UPDATE inventory SET itemstock = itemstock + qty WHERE itemcode = itmCode;
                DELETE FROM salesline WHERE stransactionid = sTransId;
                DELETE FROM salestransaction WHERE stransactionid = sTransId;
            ELSE
                RAISE 'Transaction not found.';
        END IF;
        COMMIT;
    END
$$;

alter procedure deletesales(inout integer, integer, integer) owner to postgres;

