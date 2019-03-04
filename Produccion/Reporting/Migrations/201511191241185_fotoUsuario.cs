namespace Reporting.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class fotoUsuario : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.AspNetUsers", "Image", c => c.Binary());
        }
        
        public override void Down()
        {
            DropColumn("dbo.AspNetUsers", "Image");
        }
    }
}
