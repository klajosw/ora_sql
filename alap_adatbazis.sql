/* TÁBLÁK LÉTREHOZÁSA */
CREATE TABLE customers (
    customer_id         NUMBER,
    last_name  VARCHAR2(100),
    first_name VARCHAR2(100),
    city       VARCHAR2(100),
    company    VARCHAR2(100));
ALTER TABLE customers ADD CONSTRAINT c_pk PRIMARY KEY
  (customer_id); 

CREATE TABLE orders (
    order_id     NUMBER,
    customer_id  NUMBER,
    order_date   DATE,
    shipped_date DATE,
    ship_name    VARCHAR2(100),
    ship_address VARCHAR2(100),
    ship_city    VARCHAR2(100),
    shipping_fee NUMBER,
    payment_type VARCHAR2(25),
    paid_date    DATE,
    status       VARCHAR2(100));
ALTER TABLE orders ADD CONSTRAINT o_pk PRIMARY KEY
  (order_id); 

ALTER TABLE orders
ADD CONSTRAINT o_fk
   FOREIGN KEY (customer_id)
   REFERENCES customers (customer_id);

CREATE TABLE address
  ( cim VARCHAR2(100) );

/* TÁBLÁK FELTÖLTÉSE */
INSERT INTO customers VALUES (1, 'Bedecs', 'Anna', 'Seattle', 'Company A');
INSERT INTO customers VALUES (2, 'Gratacos Solsona', 'Antonio', 'Boston', 'Company B');
INSERT INTO customers VALUES (3, 'Axen', 'Thomas', 'Los Angelas', 'Company C');
INSERT INTO customers VALUES (4, 'Lee', 'Christina', 'New York', 'Company D');
INSERT INTO customers VALUES (5, 'O’Donnell', 'Martin', 'Minneapolis', 'Company E');
INSERT INTO customers VALUES (6, 'Pérez-Olaeta', 'Francisco', 'Milwaukee', 'Company F');
INSERT INTO customers VALUES (7, 'Xie', 'Ming-Yang', 'Boise', 'Company G');
INSERT INTO customers VALUES (8, 'Andersen', 'Elizabeth', 'Portland', 'Company H');
INSERT INTO customers VALUES (9, 'Mortensen', 'Sven', 'Salt Lake City', 'Company I');
INSERT INTO customers VALUES (10, 'Wacker', 'Roland', 'Chicago', 'Company J');
INSERT INTO customers VALUES (11, 'Krschne', 'Peter', 'Miami', 'Company K');
INSERT INTO customers VALUES (12, 'Edwards', 'John', 'Las Vegas', 'Company L');
INSERT INTO customers VALUES (13, 'Ludick', 'Andre', 'Memphis', 'Company M');
INSERT INTO customers VALUES (14, 'Grilo', 'Carlos', 'Denver', 'Company N');
INSERT INTO customers VALUES (15, 'Kupkova', 'Helena', 'Honolulu', 'Company O');
INSERT INTO customers VALUES (16, 'Goldschmidt', 'Daniel', 'San Francisco', 'Company P');
INSERT INTO customers VALUES (17, 'Bagel', 'Jean Philippe', 'Seattle', 'Company Q');
INSERT INTO customers VALUES (18, 'Autier Miconi', 'Catherine', 'Boston', 'Company R');
INSERT INTO customers VALUES (19, 'Eggerer', 'Alexander', 'Los Angelas', 'Company S');
INSERT INTO customers VALUES (20, 'Li', 'George', 'New York', 'Company T');
INSERT INTO customers VALUES (21, 'Tham', 'Bernard', 'Minneapolis', 'Company U');
INSERT INTO customers VALUES (22, 'Ramos', 'Luciana', 'Milwaukee', 'Company V');
INSERT INTO customers VALUES (23, 'Entin', 'Michael', 'Portland', 'Company W');
INSERT INTO customers VALUES (24, 'Hasselberg', 'Jonas', 'Salt Lake City', 'Company X');
INSERT INTO customers VALUES (25, 'Rodman', 'John', 'Chicago', 'Company Y');
INSERT INTO customers VALUES (26, 'Liu', 'Run', 'Miami', 'Company Z');
INSERT INTO customers VALUES (27, 'Toh', 'Karen', 'Las Vegas', 'Company AA');
INSERT INTO customers VALUES (28, 'Raghav', 'Amritansh', 'Memphis', 'Company BB');
INSERT INTO customers VALUES (29, 'Lee', 'Soo Jung', 'Denver', 'Company CC');
COMMIT;

INSERT INTO orders VALUES (30, 27, to_date('20160115', 'yyyymmdd'), to_date('20160122', 'yyyymmdd'), 'Karen Toh', '789 27th Street', 'Las Vegas', 200, 'Check', to_date('20160115', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (31, 4, to_date('20160120', 'yyyymmdd'), to_date('20160122', 'yyyymmdd'), 'Christina Lee', '123 4th Street', 'New York', 5, 'Credit Card', to_date('20160120', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (32, 12, to_date('20160122', 'yyyymmdd'), to_date('20160122', 'yyyymmdd'), 'John Edwards', '123 12th Street', 'Las Vegas', 5, 'Credit Card', to_date('20160122', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (33, 8, to_date('20160130', 'yyyymmdd'), to_date('20160131', 'yyyymmdd'), 'Elizabeth Andersen', '123 8th Street', 'Portland', 50, 'Credit Card', to_date('20160130', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (34, 4, to_date('20160206', 'yyyymmdd'), to_date('20160207', 'yyyymmdd'), 'Christina Lee', '123 4th Street', 'New York', 4, 'Check', to_date('20160206', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (35, 29, to_date('20160210', 'yyyymmdd'), to_date('20160212', 'yyyymmdd'), 'Soo Jung Lee', '789 29th Street', 'Denver', 7, 'Check', to_date('20160210', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (36, 3, to_date('20160223', 'yyyymmdd'), to_date('20160225', 'yyyymmdd'), 'Thomas Axen', '123 3rd Street', 'Los Angelas', 7, 'Cash', to_date('20160223', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (37, 6, to_date('20160306', 'yyyymmdd'), to_date('20160309', 'yyyymmdd'), 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 34, 'Credit Card', to_date('20160306', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (38, 28, to_date('20160310', 'yyyymmdd'), to_date('20160311', 'yyyymmdd'), 'Amritansh Raghav', '789 28th Street', 'Memphis', 10, 'Check', to_date('20160310', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (39, 8, to_date('20160322', 'yyyymmdd'), to_date('20160324', 'yyyymmdd'), 'Elizabeth Andersen', '123 8th Street', 'Portland', 5, 'Check', to_date('20160322', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (40, 10, to_date('20160324', 'yyyymmdd'), to_date('20160324', 'yyyymmdd'), 'Roland Wacker', '123 10th Street', 'Chicago', 9, 'Credit Card', to_date('20160324', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (41, 7, to_date('20160324', 'yyyymmdd'), to_date('', 'yyyymmdd'), 'Ming-Yang Xie', '123 7th Street', 'Boise', 0, '', to_date('', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (42, 10, to_date('20160324', 'yyyymmdd'), to_date('20160407', 'yyyymmdd'), 'Roland Wacker', '123 10th Street', 'Chicago', 0, '', to_date('', 'yyyymmdd'), 'Shipped');
INSERT INTO orders VALUES (43, 11, to_date('20160324', 'yyyymmdd'), to_date('', 'yyyymmdd'), 'Peter Krschne', '123 11th Street', 'Miami', 0, '', to_date('', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (44, 1, to_date('20160324', 'yyyymmdd'), to_date('', 'yyyymmdd'), 'Anna Bedecs', '123 1st Street', 'Seattle', 0, '', to_date('', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (45, 28, to_date('20160407', 'yyyymmdd'), to_date('20160407', 'yyyymmdd'), 'Amritansh Raghav', '789 28th Street', 'Memphis', 40, 'Credit Card', to_date('20160407', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (46, 9, to_date('20160405', 'yyyymmdd'), to_date('20160405', 'yyyymmdd'), 'Sven Mortensen', '123 9th Street', 'Salt Lake City', 100, 'Check', to_date('20160405', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (47, 6, to_date('20160408', 'yyyymmdd'), to_date('20160408', 'yyyymmdd'), 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 300, 'Credit Card', to_date('20160408', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (48, 8, to_date('20160405', 'yyyymmdd'), to_date('20160405', 'yyyymmdd'), 'Elizabeth Andersen', '123 8th Street', 'Portland', 50, 'Check', to_date('20160405', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (50, 25, to_date('20160405', 'yyyymmdd'), to_date('20160405', 'yyyymmdd'), 'John Rodman', '789 25th Street', 'Chicago', 5, 'Cash', to_date('20160405', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (51, 26, to_date('20160405', 'yyyymmdd'), to_date('20160405', 'yyyymmdd'), 'Run Liu', '789 26th Street', 'Miami', 60, 'Credit Card', to_date('20160405', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (55, 29, to_date('20160405', 'yyyymmdd'), to_date('20160405', 'yyyymmdd'), 'Soo Jung Lee', '789 29th Street', 'Denver', 200, 'Check', to_date('20160405', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (56, 6, to_date('20160403', 'yyyymmdd'), to_date('20160403', 'yyyymmdd'), 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 0, 'Check', to_date('20160403', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (57, 27, to_date('20160422', 'yyyymmdd'), to_date('20160422', 'yyyymmdd'), 'Karen Toh', '789 27th Street', 'Las Vegas', 200, 'Check', to_date('20160422', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (58, 4, to_date('20160422', 'yyyymmdd'), to_date('20160422', 'yyyymmdd'), 'Christina Lee', '123 4th Street', 'New York', 5, 'Credit Card', to_date('20160422', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (59, 12, to_date('20160422', 'yyyymmdd'), to_date('20160422', 'yyyymmdd'), 'John Edwards', '123 12th Street', 'Las Vegas', 5, 'Credit Card', to_date('20160422', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (60, 8, to_date('20160430', 'yyyymmdd'), to_date('20160430', 'yyyymmdd'), 'Elizabeth Andersen', '123 8th Street', 'Portland', 50, 'Credit Card', to_date('20160430', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (61, 4, to_date('20160407', 'yyyymmdd'), to_date('20160407', 'yyyymmdd'), 'Christina Lee', '123 4th Street', 'New York', 4, 'Check', to_date('20160407', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (62, 29, to_date('20160412', 'yyyymmdd'), to_date('20160412', 'yyyymmdd'), 'Soo Jung Lee', '789 29th Street', 'Denver', 7, 'Check', to_date('20160412', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (63, 3, to_date('20160425', 'yyyymmdd'), to_date('20160425', 'yyyymmdd'), 'Thomas Axen', '123 3rd Street', 'Los Angelas', 7, 'Cash', to_date('20160425', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (64, 6, to_date('20160509', 'yyyymmdd'), to_date('20160509', 'yyyymmdd'), 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 12, 'Credit Card', to_date('20160509', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (65, 28, to_date('20160511', 'yyyymmdd'), to_date('20160511', 'yyyymmdd'), 'Amritansh Raghav', '789 28th Street', 'Memphis', 10, 'Check', to_date('20160511', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (66, 8, to_date('20160524', 'yyyymmdd'), to_date('20160524', 'yyyymmdd'), 'Elizabeth Andersen', '123 8th Street', 'Portland', 5, 'Check', to_date('20160524', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (67, 10, to_date('20160524', 'yyyymmdd'), to_date('20160524', 'yyyymmdd'), 'Roland Wacker', '123 10th Street', 'Chicago', 9, 'Credit Card', to_date('20160524', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (68, 7, to_date('20160524', 'yyyymmdd'), to_date('', 'yyyymmdd'), 'Ming-Yang Xie', '123 7th Street', 'Boise', 0, '', to_date('', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (69, 10, to_date('20160524', 'yyyymmdd'), to_date('', 'yyyymmdd'), 'Roland Wacker', '123 10th Street', 'Chicago', 0, '', to_date('', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (70, 11, to_date('20160524', 'yyyymmdd'), to_date('', 'yyyymmdd'), 'Peter Krschne', '123 11th Street', 'Miami', 0, '', to_date('', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (71, 1, to_date('20160524', 'yyyymmdd'), to_date('', 'yyyymmdd'), 'Anna Bedecs', '123 1st Street', 'Seattle', 0, '', to_date('', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (72, 28, to_date('20160607', 'yyyymmdd'), to_date('20160607', 'yyyymmdd'), 'Amritansh Raghav', '789 28th Street', 'Memphis', 40, 'Credit Card', to_date('20160607', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (73, 9, to_date('20160605', 'yyyymmdd'), to_date('20160605', 'yyyymmdd'), 'Sven Mortensen', '123 9th Street', 'Salt Lake City', 100, 'Check', to_date('20160605', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (74, 6, to_date('20160608', 'yyyymmdd'), to_date('20160608', 'yyyymmdd'), 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 300, 'Credit Card', to_date('20160608', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (75, 8, to_date('20160605', 'yyyymmdd'), to_date('20160605', 'yyyymmdd'), 'Elizabeth Andersen', '123 8th Street', 'Portland', 50, 'Check', to_date('20160605', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (76, 25, to_date('20160605', 'yyyymmdd'), to_date('20160605', 'yyyymmdd'), 'John Rodman', '789 25th Street', 'Chicago', 5, 'Cash', to_date('20160605', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (77, 26, to_date('20160605', 'yyyymmdd'), to_date('20160605', 'yyyymmdd'), 'Run Liu', '789 26th Street', 'Miami', 60, 'Credit Card', to_date('20160605', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (78, 29, to_date('20160605', 'yyyymmdd'), to_date('20160605', 'yyyymmdd'), 'Soo Jung Lee', '789 29th Street', 'Denver', 200, 'Check', to_date('20160605', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (79, 6, to_date('20160623', 'yyyymmdd'), to_date('20160623', 'yyyymmdd'), 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 0, 'Check', to_date('20160623', 'yyyymmdd'), 'Closed');
INSERT INTO orders VALUES (80, 4, to_date('20160425', 'yyyymmdd'), to_date('', 'yyyymmdd'), 'Christina Lee', '123 4th Street', 'New York', 0, '', to_date('', 'yyyymmdd'), 'New');
INSERT INTO orders VALUES (81, 3, to_date('20160425', 'yyyymmdd'), to_date('', 'yyyymmdd'), 'Thomas Axen', '123 3rd Street', 'Los Angelas', 0, '', to_date('', 'yyyymmdd'), 'New');
COMMIT;

INSERT INTO address VALUES('7632      PÉCS                                     EGRESSY GÁBOR U.22.                ');
INSERT INTO address VALUES('7913      SZENTDÉNES                               PETÕFI U.104.                      ');
INSERT INTO address VALUES('7953      KIRÁLYEGYHÁZA                            PETÕFI U.172.                      ');
INSERT INTO address VALUES('7530      KADARKÚT                                 KÖRMENDI U. 45.');
INSERT INTO address VALUES('7900      SZIGETVÁR                                GÁBOR ÁRON U.8.                    ');
INSERT INTO address VALUES('7370      SÁSD                                     KOSSUTH U.16.                      ');
INSERT INTO address VALUES('7636      PÉCS                                     TILDY Z.U.27.                      ');
INSERT INTO address VALUES('7633      PÉCS                                     HAJNÓCZY J U 1/B EBH FIÓK:7.');
INSERT INTO address VALUES('7985      DOBSZA                                   FÕ U. 4.                           ');
INSERT INTO address VALUES('7621      PÉCS                                     PERCZEL U.35.                      ');
INSERT INTO address VALUES('7900      SZIGETVÁR                                JÓZSEF A.U.972/3 HRSZ.             ');
INSERT INTO address VALUES('7624      PÉCS                                     JÓZSEF A.U.26. EBH FIÓK:6');
INSERT INTO address VALUES('7621      PÉCS                                     SALLAI U.22                        ');
INSERT INTO address VALUES('7754      BÓLY                                     EÖTVÖS U.1.                        ');
INSERT INTO address VALUES('7624      PÉCS                                     TIBORC U. 78/2                     ');
INSERT INTO address VALUES('7624      PÉCS                                     JURISICS M.U.39                    ');
INSERT INTO address VALUES('7625      PÉCS                                     VILMOS                             39/A');
INSERT INTO address VALUES('7624      PÉCS                                     ALKOTMÁNY U.12.                    ');
INSERT INTO address VALUES('7763      SZÕKÉD                                   ADY E.U.22.                        ');
INSERT INTO address VALUES('7624      PÉCS                                     ALKOTMÁNY U.12.   MB 12.           ');
INSERT INTO address VALUES('7385      GÖDRESZENTMÁRTON                         ARANY J. U.8.                      ');
INSERT INTO address VALUES('7616      PÉCS                                     PF.45.                             ');
INSERT INTO address VALUES('8800      NAGYKANIZSA      ');
INSERT INTO address VALUES('7800      SIKLÓS                                   FELSZABADULÁS U. 3. 1/3.');
INSERT INTO address VALUES('7975      KÉTÚJFALU                                ARANY J.U.34.                      ');
INSERT INTO address VALUES('8692      SZÕLÕSGYÖRÖK                             KÖZTÁRSASÁG U.60.                  ');
INSERT INTO address VALUES('7624      PÉCS                                     DAMJANICH U.46.                    ');
INSERT INTO address VALUES('7668      KESZÜ                                    PETÕFI U.121.                      ');
INSERT INTO address VALUES('7630      PÉCS                                     DIÓSI U.1.                         ');
INSERT INTO address VALUES('7622      PÉCS                                     BAJCSY ZS.U.14-16.');
INSERT INTO address VALUES('7624      PÉCS                                     BUDAI NAGY ANTAL U.1.              ');
INSERT INTO address VALUES('7976      ZÁDOR                                    PETÕFI U.1.                        ');
INSERT INTO address VALUES('7300      KOMLÓ                                    ANNA AKNA');
INSERT INTO address VALUES('7624      PÉCS                                     SÁFRÁNY U.12/9.                    ');
INSERT INTO address VALUES('7729      GÖRCSÖNYDOBOKA                           SALLAI U.29.                       ');
INSERT INTO address VALUES('7953      KIRÁLYEGYHÁZA                            PETÕFI U.155.                      ');
INSERT INTO address VALUES('9400      SOPRON                                   ADY ENDRE U.5.                     ');
INSERT INTO address VALUES('7624      PÉCS                                     ALKOTMÁNY U.12.                    ');
INSERT INTO address VALUES('7625      PÉCS                                     SZÕLÕ U.32.                        ');
INSERT INTO address VALUES('1136      BUDAPEST                                 PANNÓNIA U.58.                     ');
INSERT INTO address VALUES('8200      VESZPRÉM                                 CSILLAG U.20/A..3/12.');
INSERT INTO address VALUES('7632      PÉCS                                     NAGY I.U.68.                       ');
INSERT INTO address VALUES('7635      PÉCS                                     HOLLÓ DÜLÕ 1.                      ');
INSERT INTO address VALUES('7634      PÉCS                                     PELLÉRDI ÚT 55                     ');
INSERT INTO address VALUES('7612      PÉCS                                     PF:11.');
INSERT INTO address VALUES('7632      PÉCS                                     MÓRA FERENC ÚT                     73');
INSERT INTO address VALUES('1131      BUDAPEST                                 FALUDI U.3.                        ');
INSERT INTO address VALUES('7200      DOMBÓVÁR                                 KÓRHÁZ U 11                        ');
INSERT INTO address VALUES('7741      BOGÁD                                    VIRÁG U. 7.                        ');
COMMIT;


/*
DROP TABLE orders;
DROP TABLE customers;
DROP TABLE address;
*/
