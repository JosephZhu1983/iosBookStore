
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BookStoreService.Models;

namespace BookStoreService.Controllers
{
    public class OrderController : Controller
    {
        public class OrderItemParm
        {
            public int bookid { get; set; }

            public int qty { get; set; }
        }

        public ActionResult GetOrders(int userid)
        {
            try
            {
                using (BookStoreDataContext data = new BookStoreDataContext())
                {
                    var user = data.Users.SingleOrDefault(_ => _.ID == userid);
                    if (user != null)
                    {
                        return Json(new
                        {
                            results = data.Orders.Where(o=>o.UserId == userid).Select(_ => new
                            {
                                orderid = _.ID,
                                totalprice = _.TotalPrice,
                                time = _.Time,
                                orderitems = _.OrderItems.Select(__ => new
                                {
                                    bookid = __.BookId,
                                    bookname = data.Books.SingleOrDefault(b => b.ID == __.BookId).Name,
                                    price = __.Price,
                                    totalprice = __.TotalPrice,
                                    qty = __.Qty
                                }).ToList(),
                            }).OrderByDescending(_ => _.time).ToList()
                        , success = true }, JsonRequestBehavior.AllowGet);
                    }
                    else
                        return Json(new { success = false, reason = "usernotexists" }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, reason = "servererror" }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult SubmitOrder(int userid, string bookids, string qtys)
        {
            try
            {
                var items = new List<OrderItemParm>();
                var bookidArray = bookids.Split(',').Select(a=> int.Parse(a)).ToList();
                var qtyArray = qtys.Split(',').Select(a => int.Parse(a)).ToList();
                for (int i = 0; i < bookidArray.Count; i++)
                {
                    items.Add(new OrderItemParm
                    {
                        bookid = bookidArray[i],
                        qty = qtyArray[i]
                    });
                }
                using (BookStoreDataContext data = new BookStoreDataContext())
                {
                    var user = data.Users.SingleOrDefault(_ => _.ID == userid);
                    if (user != null)
                    {
                        var order = new Order
                        {
                            Time = DateTime.Now,
                            UserId = userid,
                        };
                        foreach (var bookid in bookidArray)
                        {
                            var book = data.Books.SingleOrDefault(b => b.ID == bookid);
                            if (book != null)
                            {
                                var oi = new OrderItem
                                {
                                    BookId = bookid,
                                    Price = book.Price,
                                    Qty = items.Single(a => a.bookid == bookid).qty,
                                };
                                oi.TotalPrice = oi.Price * oi.Qty;
                                order.OrderItems.Add(oi);
                            }
                        }

                        order.TotalPrice = order.OrderItems.Sum(_ => _.TotalPrice);
                        data.Orders.InsertOnSubmit(order);
                        data.SubmitChanges();
                        return Json(new { results = new { orderid = order.ID }, success = true }, JsonRequestBehavior.AllowGet);
                    }
                    else
                        return Json(new { success = false, reason = "usernotexists" }, JsonRequestBehavior.AllowGet);

                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, reason = "servererror" }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}
