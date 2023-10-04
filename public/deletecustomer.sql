create procedure deletecustomer(INOUT cuscode integer, INOUT addressid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        addressId = (SELECT CAddressId FROM CustomerAddress WHERE CustomerCode=cusCode);
        DELETE FROM CustomerContact WHERE CAddressId = addressId;
        DELETE FROM CustomerAddress WHERE CustomerCode = cusCode;
        DELETE FROM Customers WHERE CustomerCode = cusCode;
        COMMIT;
    END
$$;

alter procedure deletecustomer(inout integer, inout integer) owner to postgres;

