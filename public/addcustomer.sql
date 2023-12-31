create procedure addcustomer(IN fname character varying, IN lname character varying, IN street character varying, IN city character varying, IN country character varying, IN contact character varying, INOUT addressid integer DEFAULT 0, INOUT cuscode integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        INSERT INTO Customers (FirstName, lastname, TimeStamp) VALUES (fname, lname, current_timestamp)
        RETURNING (SELECT currval('customers_customercode_seq')) INTO cusCode;

        INSERT INTO CustomerAddress (CustomerCode, CStreet, CCity, CCountry) VALUES (cusCode, street, city, country)
        RETURNING (SELECT currval('customeraddress_caddressid_seq')) INTO addressId;

        INSERT INTO CustomerContact (CAddressId, CContactNumber)VALUES (addressId, contact);

        COMMIT;
    END
$$;

alter procedure addcustomer(varchar, varchar, varchar, varchar, varchar, varchar, inout integer, inout integer) owner to postgres;

