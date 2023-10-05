create procedure deletecustomer(INOUT cuscode integer, INOUT addressid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        IF EXISTS(SELECT CustomerCode FROM customers WHERE customercode=cusCode)
            THEN
                IF NOT EXISTS(SELECT customercode FROM salestransaction WHERE customercode=cusCode)
                    THEN
                        addressId = (SELECT CAddressId FROM CustomerAddress WHERE CustomerCode=cusCode);
                        DELETE FROM CustomerContact WHERE CAddressId = addressId;
                        DELETE FROM CustomerAddress WHERE CustomerCode = cusCode;
                        DELETE FROM Customers WHERE CustomerCode = cusCode;
                    ELSE RAISE 'Cannot delete customer with transactions.';
                end if;
            ELSE RAISE 'Customer does not exists.';
        END IF;
        COMMIT;
    END
$$;

alter procedure deletecustomer(inout integer, inout integer) owner to postgres;

