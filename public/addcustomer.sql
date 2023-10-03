create procedure addcustomer(INOUT cuscode integer, IN fname character varying, IN lname character varying, INOUT addressid integer, IN street character varying, IN city character varying, IN country character varying, IN contact character varying)
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

alter procedure addcustomer(inout integer, varchar, varchar, inout integer, varchar, varchar, varchar, varchar) owner to postgres;

