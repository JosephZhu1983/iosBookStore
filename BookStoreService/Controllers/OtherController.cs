using BookStoreService.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Mvc;

namespace BookStoreService.Controllers
{
    public class ViewLogParm
    {
        public int bookid { get; set; }

        public DateTime time { get; set; }
    }

    public class OtherController : Controller
    {
        public ActionResult SubmitViewLogs(int userid, string bookids, string times)
        {
            Thread.Sleep(1000);
            var items = new List<ViewLogParm>();
            var bookidArray = bookids.Split(',').Select(a => int.Parse(a)).ToList();
            var timeArray = times.Split(',').Select(a => DateTime.Parse(a)).ToList();
            for (int i = 0; i < bookidArray.Count; i++)
            {
                items.Add(new ViewLogParm
                {
                    bookid = bookidArray[i],
                    time = timeArray[i]
                });
            }

            using (BookStoreDataContext data = new BookStoreDataContext())
            {
                data.ViewLogs.InsertAllOnSubmit(items.Select(_ => new ViewLog
                {
                    BookId = _.bookid,
                    Time = _.time,
                    UserId = userid
                }).ToList());
                data.SubmitChanges();
                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}
