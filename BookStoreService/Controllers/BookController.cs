using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BookStoreService.Models;
using System.Threading;

namespace BookStoreService.Controllers
{
    public class BookController : Controller
    {
        public ActionResult GetBooks(int? categoryid, int? pageindex, int? pagesize)
        {
            try
            {
                using (BookStoreDataContext data = new BookStoreDataContext())
                {
                    var query = data.Books.Select(_ => new
                    {
                        categoryId = _.CategoryId,
                        bookid = _.ID,
                        bookname = _.Name,
                        categoryname = _.Category.Name,
                        imagename = _.ImageName,
                        bookprice = _.Price,
                        bookdesc = _.Description
                    });
                    if (categoryid != null)
                        query = query.Where(_ => _.categoryId == categoryid.Value);
                    if (pageindex != null)
                        query = query.Skip(pagesize.Value * pageindex.Value);
                    if (pagesize != null)
                        query = query.Take(pagesize.Value);

                    var result = query.ToList();
                    return Json(new { success = true, results = result }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, reason = "servererror" }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult GetBooksByIds(string bookids)
        {
            try
            {
                using (BookStoreDataContext data = new BookStoreDataContext())
                {
                    var bookidArray = bookids.Split(',').Select(_=> int.Parse(_)).ToArray();
                    var query = data.Books.Where(book => bookidArray.Contains(book.ID)).Select(_ => new
                    {
                        categoryId = _.CategoryId,
                        bookid = _.ID,
                        bookname = _.Name,
                        categoryname = _.Category.Name,
                        imagename = _.ImageName,
                        bookprice = _.Price,
                    });
                    var result = query.ToList();
                    return Json(new { success = true, results = result }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, reason = "servererror" }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult GetBookCategories()
        {
            try
            {
                using (BookStoreDataContext data = new BookStoreDataContext())
                {
                    return Json(new
                    {
                        success = true,
                        results = data.Categories.Select(_ => new
                        {
                            id = _.ID,
                            name = _.Name,
                        }).ToList()
                    }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, reason = "servererror" }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}
