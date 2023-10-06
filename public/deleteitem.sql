create procedure deleteitem(INOUT itmcode integer)
    language plpgsql
as
$$
    BEGIN
        IF EXISTS(SELECT itemcode FROM item WHERE itemcode = itmCode)
            THEN
               IF NOT EXISTS(SELECT itemcode FROM deliveryline WHERE itemcode = itmCode)
                    THEN
                        IF NOT EXISTS(SELECT itemcode FROM salesline WHERE itemcode = itmCode)
                                THEN
                                    DELETE FROM inventory WHERE itemcode = itmCode;
                                    DELETE FROM itemuom WHERE itemcode = itmCode;
                                    DELETE FROM item WHERE itemcode = itmCode;
                                ELSE
                                    RAISE 'Item used in sales transactions.';
                        END IF;
                    ELSE
                        RAISE 'Item used in delivery transactions.';
                END IF;
            ELSE
                RAISE 'Item does not exists.';
        END IF;
        COMMIT;
    END
$$;

alter procedure deleteitem(inout integer) owner to postgres;

