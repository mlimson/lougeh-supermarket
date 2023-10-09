create procedure deletedelivery(INOUT dtransid integer, IN itmcode integer DEFAULT 0, IN qty integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        IF EXISTS (SELECT dtransactionid FROM deliverytransaction WHERE dtransactionid = dTransId)
            THEN
                qty = (SELECT dqty FROM deliveryline WHERE dtransactionid = dTransId);
                itmCode = (SELECT itemcode FROM deliveryline WHERE dtransactionid = dTransId);
                IF (((SELECT itemstock FROM inventory WHERE itemcode = itmCode)-qty) >= 0)
                    THEN
                        UPDATE inventory SET itemstock = itemstock - qty WHERE itemcode = itmCode;
                        DELETE FROM deliveryline WHERE dtransactionid = dTransId;
                        DELETE FROM deliverytransaction WHERE dtransactionid = dTransId;
                    ELSE RAISE 'Deleting delivery will result to a negative inventory.';
                END IF;
            ELSE RAISE 'Delivery transaction does not exists.';
        END IF;
        COMMIT;
    END
$$;

alter procedure deletedelivery(inout integer, integer, integer) owner to postgres;

