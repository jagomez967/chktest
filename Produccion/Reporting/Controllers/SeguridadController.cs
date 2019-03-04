using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Reporting.Models;
using Reporting.ViewModels;
using System.Data.Entity;
using Microsoft.AspNet.Identity;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;

namespace Reporting.Controllers
{
    [Authorize(Roles = "Administrador")]
    public class SeguridadController : Controller
    {
        private ApplicationDbContext context = new ApplicationDbContext();
        private ITableroRepository repository;
        public SeguridadController(ApplicationDbContext context, ITableroRepository tableroRepository)
        {
            this.context = context;
            this.repository = tableroRepository;
        }

        //ABM de Usuarios
        public ActionResult Usuarios()
        {
            var userId = User.Identity.GetUserId<int>();
            List<ApplicationUser> users = context.Users.ToList();

            return View(users);
        }

        //ABM de Roles
        public ActionResult Roles()
        {
            return View();
        }

        //Asignar Roles y Usuarios
        public ActionResult RolUsuario()
        {
            return View();
        }

        //Asignar Clientes y Usuarios
        public ActionResult ClienteUsuario()
        {
            return View();
        }

        public ActionResult DeleteUsuario(int Id)
        {
            try
            {
                ApplicationUser userEliminar = context.Users.First(u => u.Id == Id);
                context.Users.Remove(userEliminar);
                context.SaveChanges();

                return Content(Boolean.TrueString);
            }
            catch
            {
                return Content(Boolean.FalseString);
            }
        }

        public ActionResult VerUsuario(int Id)
        {
            UserViewModel model = new UserViewModel();

            var user = context.Users.FirstOrDefault(u => u.Id == Id);
            if (user == null)
                return View("Error404");

            var roles = user.Roles;

            foreach (CustomUserRole rolUsu in roles)
            {
                var rol = context.Roles.First(r => r.Id == rolUsu.RoleId);
                model.Roles.Add(new RolViewModel() { Id = rol.Id, Name = rol.Name });
            }
            
            model.Id = user.Id;
            model.LastName = user.LastName;
            model.FirstName = user.FirstName;
            model.CellPhone = user.CellPhone;
            model.UserName = user.UserName;

            return View(model);
        }

        public ActionResult EditarUsuario(int Id)
        {
            var usuarioLogeado = User.Identity.GetUserId<int>();

            var usuarioEditar = context.Users.FirstOrDefault(u => u.Id == Id);

            if (usuarioEditar == null)
                return View("Error404");

            EditarUsuarioViewModel model = new EditarUsuarioViewModel();

            var roles = context.Roles;

            foreach (CustomRole rol in roles)
            {
                model.Roles.Add(new UsuarioRolViewModel() { RolId = rol.Id, Name = rol.Name, Selected=false });
            }

            var rolesUsuario = usuarioEditar.Roles;

            foreach (CustomUserRole rol in rolesUsuario)
            {
                var rolenusuario = model.Roles.FirstOrDefault(r => r.RolId == rol.RoleId);
                if (rolenusuario != null) rolenusuario.Selected = true;
            }

            model.Id = usuarioEditar.Id;
            model.LastName = usuarioEditar.LastName;
            model.FirstName = usuarioEditar.FirstName;
            model.CellPhone = usuarioEditar.CellPhone;
            model.UserName = usuarioEditar.UserName;

            return View(model);
        }

        [HttpPost]
        public ActionResult EditarUsuario(EditarUsuarioViewModel model)
        {
            try
            {
                if (!ModelState.IsValid)
                    return View();

                
                var user = context.Users.First(u => u.Id == model.Id);
                
                user.Roles.Clear();

                foreach (UsuarioRolViewModel rol in model.Roles.Where(r=>r.Selected))
                {
                    user.Roles.Add(new CustomUserRole() { RoleId = rol.RolId, UserId = model.Id });
                }

                user.CellPhone = model.CellPhone;
                user.FirstName = model.FirstName;
                user.LastName = model.LastName;

                context.Users.Attach(user);
                context.Entry(user).State = EntityState.Modified;
                context.SaveChanges();

                return RedirectToAction("Usuarios");
            }
            catch
            {
                return View();
            }
        }
    }
}