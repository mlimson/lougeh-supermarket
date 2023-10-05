create procedure deletesupplier(INOUT supcode integer, INOUT addressid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        IF EXISTS(SELECT SupplierCode FROM suppliers WHERE suppliercode=supCode)
            THEN
                IF NOT EXISTS(SELECT SupplierCode FROM deliverytransaction WHERE suppliercode=supCode)
                    THEN
                        addressId = (SELECT SAddressId FROM SupplierAddress WHERE SupplierCode=supCode);
                        DELETE FROM SupplierContact WHERE SAddressId = addressId;
                        DELETE FROM SupplierAddress WHERE SupplierCode = supCode;
                        DELETE FROM Suppliers WHERE SupplierCode = supCode;
                    ELSE RAISE 'Cannot delete supplier with transactions.';
                end if;
            ELSE RAISE 'Supplier does not exists.';
        END IF;
        COMMIT;
    END
$$;

alter procedure deletesupplier(inout integer, inout integer) owner to postgres;

