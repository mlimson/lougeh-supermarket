create procedure addsales(IN cuscode integer, IN itmcode integer, IN qty integer, IN itmcost numeric, INOUT stransid integer DEFAULT 0, INOUT invid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        IF((SELECT itemstock FROM inventory WHERE itemcode=itmCode) >= qty)
        THEN
            INSERT INTO salestransaction (customercode, timestamp) VALUES (cusCode, current_timestamp)
            RETURNING (SELECT currval('salestransaction_stransactionid_seq')) INTO stransId;
            UPDATE inventory SET itemstock = itemstock - qty WHERE itemcode = itmCode;
            invId = (SELECT inventoryid FROM inventory WHERE itemcode = itmCode);
            INSERT INTO salesline (stransactionid, inventoryid, itemcode, sqty, saleprice) VALUES (stransId, invId, itmCode, qty, itmCost);
        ELSE
            RAISE NOTICE 'Not enough quantity in inventory.';
        END IF;
        COMMIT;
    END
$$;

alter procedure addsales(integer, integer, integer, numeric, inout integer, inout integer) owner to postgres;

