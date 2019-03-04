namespace Reporting.Migrations
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;
    using Microsoft.AspNet.Identity;
    using Microsoft.AspNet.Identity.EntityFramework;
    using Reporting.Models;


    internal sealed class Configuration : DbMigrationsConfiguration<Reporting.Models.ApplicationDbContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
            ContextKey = "Reporting.Models.ApplicationDbContext";
        }

        protected override void Seed(Reporting.Models.ApplicationDbContext context)
        {
            if (!context.Roles.Any(r => r.Id == (int)Roles.Admin))
            {
                new RoleManager<CustomRole, int>(new CustomRoleStore(context)).Create(new CustomRole() { Id=1, Name = "Administrador" });
            }

            if (!context.Roles.Any(r => r.Id == (int)Roles.User))
            {
                new RoleManager<CustomRole, int>(new CustomRoleStore(context)).Create(new CustomRole() {Id=2,  Name = "User" });
            }

            if (!context.Users.Any(u => u.Email == "admin@checkpos.com"))
            {
                var userStore = new CustomUserStore(context);
                var userManager = new ApplicationUserManager(userStore);
                var res = userManager.Create(new ApplicationUser() { Email = "admin@checkpos.com", UserName = "admin@checkpos.com", FirstName = "Ignacio", LastName = "Tata", CellPhone = "1124515363" }, "secret");

                if (res.Succeeded)
                {
                    var userAdmin = context.Users.First(u => u.Email == "admin@checkpos.com");
                    userAdmin.Roles.Add(new CustomUserRole() { UserId = userAdmin.Id, RoleId = (int)Roles.Admin });
                }

                context.SaveChanges();
            }
        }
    }
}
