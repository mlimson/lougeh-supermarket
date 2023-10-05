create procedure adddelivery(IN supcode integer, IN itmcode integer, IN qty integer, IN itmcost numeric, IN dtransid integer DEFAULT 0, IN invid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        INSERT INTO deliverytransaction (suppliercode, timestamp) VALUES (supCode, current_timestamp)
        RETURNING (SELECT currval('deliverytransaction_dtransactionid_seq')) INTO dtransId;
        UPDATE inventory SET itemstock = itemstock + qty WHERE itemcode = itmCode
        RETURNING (SELECT currval('inventory_inventoryid_seq')) INTO invId;
        INSERT INTO deliveryline (dtransactionid, inventoryid, itemcode, dqty, itemcost) VALUES (dtransId, invId, itmCode, qty, itmCost);
        COMMIT;
    END
$$;

alter procedure adddelivery(integer, integer, integer, numeric, integer, integer) owner to postgres;

