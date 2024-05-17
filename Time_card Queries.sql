CREATE PROCEDURE InsertTimeCard
    @dates DATETIME, 
    @earlyOut DATETIME, 
    @lateIn DATETIME = NULL, 
    @lateOut DATETIME = NULL, 
    @otHrs DATETIME,
    @status CHAR(1),
    @data CHAR(1), 
    @pnEmployeeId NVARCHAR(50),
    @flag CHAR(1) 
AS
BEGIN
    SET NOCOUNT ON;

   
    DECLARE @pnCompanyid INT;
    DECLARE @pnBranchid INT;
    DECLARE @empCode NVARCHAR(50);
    DECLARE @empName NVARCHAR(100);
    DECLARE @shiftCode VARCHAR(50);
    DECLARE @intime DATETIME;
    DECLARE @breakOut DATETIME;
    DECLARE @breakIn DATETIME;
    DECLARE @outtime DATETIME;
    DECLARE @leaveCode VARCHAR(5);

    
    SELECT @pnCompanyid = pe.pn_CompanyID,
           @pnBranchid = pe.pn_BranchID,
           @empCode = pe.EmployeeCode,
           @empName = pe.Employee_Full_Name
    FROM paym_Employee pe
    WHERE pe.pn_EmployeeID = 5;

    IF @empCode IS NULL OR @empName IS NULL
    BEGIN
        PRINT 'Error: Employee details not found';
        RETURN;
    END

    
    SELECT @shiftCode = sm.shift_Code
    FROM shift_month sm
    WHERE  sm.pn_EmployeeCode = 'EMP001'
     

    IF @shiftCode IS NULL
    BEGIN
        PRINT 'Error: Shift code not found';
        RETURN;
    END

   
    SELECT @intime = sd.start_time,
           @breakOut = sd.break_time_out,
           @breakIn = sd.break_time_in,
           @outtime = sd.end_time
    FROM shift_details sd
    WHERE sd.shift_code = 'S001'
     
    IF @intime IS NULL OR @breakOut IS NULL OR @breakIn IS NULL OR @outtime IS NULL
    BEGIN
        PRINT 'Error: Shift details not found';
        RETURN;
    END

  
    SELECT @leaveCode = ls.pn_leavecode
    FROM leave_settlement ls
    WHERE ls.pn_LeaveID = 1
    IF @leaveCode IS NULL
    BEGIN
        PRINT 'Error: Leave code not found';
        RETURN;
    END

    
    INSERT INTO time_card (pn_companyid, pn_branchid, emp_code, emp_name, shift_code, dates, days, intime, break_out, break_in, early_out, outtime, Late_in, Late_out, ot_hrs, status, leave_code, data, pn_EmployeeID, flag)
    VALUES (@pnCompanyid, @pnBranchid, @empCode, @empName, @shiftCode, @dates, DATENAME(dw, @dates), @intime, @breakOut, @breakIn, @earlyOut, @outtime, @lateIn, @lateOut, @otHrs, @status, @leaveCode, @data, @pnEmployeeId, @flag);

    PRINT 'Data inserted into time_card table';
END



EXEC InsertTimeCard
    @dates = '2024-05-14T00:00:00',
    @earlyOut = '1900-01-01T17:00:00',
    @lateIn = '2024-05-15T00:00:00',
    @lateOut ='2024-05-20T00:00:00',
    @otHrs = '1900-01-01T02:00:00',
    @status = 'P',
    @data = 'Y',
    @pnEmployeeId = 'EMP005',
    @flag = 'Z';



	select * from time_card

	Drop procedure InsertTimeCard

	select * from paym_employee

	select * from shift_month

	SELECT * FROM shift_details

	SELECT * FROM leave_settlement
