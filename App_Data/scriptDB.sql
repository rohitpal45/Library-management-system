create View   AddExtraChage
as 
SELECT 
    b.BookTitle,
    b.BookISBN,
    b.BookCategory,
    b.BookAuthor,
    b.BookPubName,
   (DATEDIFF(DAY, GETDATE(),CONVERT(DATE, TranDate, 103))-ReturnDaysLimit) * penaltyCharge AS DayMultiplier,
    t.TranDate,t.TranId,t.TranStatus,UserId
FROM 
    tblTransactions t
JOIN 
    tblBooks b ON b.BookId = t.BookId

alter table  tblBooks add   ReturnDaysLimit int not null default 0 

alter table  tblBooks add   penaltyCharge int not null default 0 