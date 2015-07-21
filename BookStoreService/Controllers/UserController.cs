using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BookStoreService.Models;
using System.Threading;

namespace BookStoreService.Controllers
{
    public class UserController : Controller
    {
        public ActionResult Login(string username, string password)
        {
            try
            {
                using (BookStoreDataContext data = new BookStoreDataContext())
                {
                    var user = data.Users.SingleOrDefault(_ => _.Username == username && _.Password == password);
                    if (user != null)
                    {
                        return Json(new { results = new { userid = user.ID }, success = true }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(new { success = false, reason = "authfailed" }, JsonRequestBehavior.AllowGet);
                    }
                }
            }
            catch(Exception ex)
            {
                return Json(new { success = false, reason = "servererror" }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult ChangePassword(int id, string password)
        {
            try
            {
                using (BookStoreDataContext data = new BookStoreDataContext())
                {
                    var user = data.Users.SingleOrDefault(_ => _.ID == id);
                    if (user != null)
                    {
                        user.Password = password;
                        data.SubmitChanges();
                        return Json(new { success = true }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(new { success = false, reason = "usernotexists" }, JsonRequestBehavior.AllowGet);
                    }
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, reason = "servererror" }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult Register(string username, string password)
        {
            try
            {
                using (BookStoreDataContext data = new BookStoreDataContext())
                {
                    var user = data.Users.SingleOrDefault(_ => _.Username == username);
                    if (user == null)
                    {
                        user = new User { Username = username, Password = password };
                        data.Users.InsertOnSubmit(user);
                        data.SubmitChanges();
                        return Json(new { results = new { userid = user.ID }, success = true }, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(new { success = false, reason = "userexists" }, JsonRequestBehavior.AllowGet);
                    }
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, reason = "servererror" }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}
