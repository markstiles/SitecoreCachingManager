using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Sitecore.Diagnostics;
using Sitecore.Caching;
using Sitecore.Web;
using Sitecore;
using Sitecore.Configuration;
using System.Text;
using Sitecore.Data.Managers;
using System.Text.RegularExpressions;
using HtmlAgilityPack;
using System.Xml.XPath;

namespace sitecore.admin
{
	public partial class CacheUI : System.Web.UI.Page
	{
		/// <summary>
		/// Names
		/// </summary>
		List<string> SiteCacheNames;
		List<string> SystemSiteCacheNames;
		List<string> DBCacheNames;
		List<string> ARCacheNames;
		List<string> MiscDBNames;
		List<string> MiscCacheNames;

		/// <summary>
		/// Types
		/// </summary>
		List<string> SiteCacheTypes;
		List<string> DBCacheTypes;

		//images
		public string SearchBtn = string.Empty;
		public string BtnClear = string.Empty;
		public string ClearAll = string.Empty;
		public string SelectAll = string.Empty;
		public string ProfileBtn = string.Empty;
		public string Summary = string.Empty;

		//Page Load Events
		protected override void OnInit(EventArgs e) {
			Assert.ArgumentNotNull(e, "e");
			base.OnInit(e);
		}

		public string GetIcon(string iconPath, int width, int height) {
			
			HtmlAgilityPack.HtmlDocument htmlDoc = new HtmlAgilityPack.HtmlDocument();
			htmlDoc.LoadHtml(ThemeManager.GetImage(iconPath, width, height));
			HtmlNode img = htmlDoc.DocumentNode.FirstChild;
			return img.Attributes["src"].Value;
		}

		private void Page_Load(object sender, EventArgs e) {

			SearchBtn = string.Format(".btn input.searchBtn {{ background: url('{0}') no-repeat 0 0; }}", GetIcon("Applications/16x16/view.png", 16, 16));
			BtnClear = string.Format(".btn input.BtnClear {{ background: url('{0}') no-repeat 0 0; }}", GetIcon("Applications/16x16/recycle.png", 16, 16));
			ClearAll = string.Format(".btn input.clearAllBtn {{ background: url('{0}') no-repeat 0 0; }}", GetIcon("Applications/16x16/refresh.png", 16, 16));
			SelectAll = string.Format(".btn a.selectAll {{ background: url('{0}') no-repeat -5px -8px; height:17px; padding:2px 4px 0 28px; }}", GetIcon("Control/32x32/checkbox_b_h.png", 32, 32));
			ProfileBtn = string.Format(".btn .profile {{ background: url('{0}') no-repeat 0 0; }} ", GetIcon("Applications/16x16/view_add.png", 16, 16));
			Summary = string.Format(".btn .summary {{ background: url('{0}') no-repeat 0 0; }}", GetIcon("Applications/16x16/view.png", 16, 16));

			imgGlobal.ImageUrl = GetIcon("Network/16x16/earth.png", 16, 16);
			imgSite.ImageUrl = GetIcon("Network/32x32/environment.png", 16, 16);
			imgDB.ImageUrl = GetIcon("Business/32x32/data_view.png", 16, 16);
			imgAR.ImageUrl = GetIcon("Network/32x32/lock.png", 16, 16);
			imgMisc.ImageUrl = GetIcon("People/16x16/cube_blue.png", 16, 16);
			
			if (!IsPostBack) {

				//site types
				SiteCacheTypes = new List<string>() { "[html]", "[xsl]", "[viewstate]", "[registry]", "[filtered items]" };
				foreach (string t in SiteCacheTypes) {
					cblSiteTypes.Items.Add(new ListItem(t, t));
				}

				//site names
				SystemSiteCacheNames = new List<string>() { "admin", "login", "modules_shell", "modules_website", "publisher", "scheduler", "service", "shell", "system", "testing", "website" };
				SiteCacheNames = new List<string>();
				foreach (string si in Factory.GetSiteNames().OrderBy(a => a)) {
					if (!SystemSiteCacheNames.Contains(si)) {
						SiteCacheNames.Add(si);
						cblSiteNames.Items.Add(new ListItem(si, si));
					} else {
						cblSysSiteNames.Items.Add(new ListItem(si, si));
					}
				}

				//db types			
				DBCacheTypes = new List<string>() { "[blobIDs]", "[data]", "[items]", "[paths]", "[standardValues]", "[pivot]" };
				foreach (string t in DBCacheTypes) {
					cblDBTypes.Items.Add(new ListItem(t, t));
				}

				//db names
				DBCacheNames = new List<string>() { "core", "master", "web", "filesystem" };
				foreach (string t in DBCacheNames) {
					cblDBNames.Items.Add(new ListItem(t, t));
				}

				//access result names 
				ARCacheNames = new List<string>() { "AccessResultCache" };
				foreach (string t in ARCacheNames) {
					cblAccessResult.Items.Add(new ListItem(t, t));
				}

				//misc names without random types
				MiscCacheNames = new List<string>() { "clientData", "IsUserInRoleCache", "LanguageProvider - Languages", "Log singles", "ProxyProvider", "SqlDataProvider - Prefetch data(core)", " 	SqlDataProvider - Prefetch data(master)", "SqlDataProvider - Prefetch data(web)", "SqlDataProvider - Property data(core)", "SqlDataProvider - Property data(master)", "SqlDataProvider - Property data(web)", "UserProfileCache", "WebUtil.QueryStringCache" };
				foreach (string t in MiscCacheNames) {
					cblMiscNames.Items.Add(new ListItem(t, t));
				}

				//saw this but it went away, newer versions most likely
				//"rules", 

				UpdateTotals();
			}
		}

		// Events
		protected void c_clearAll_Click(object sender, EventArgs e) {
			foreach (Cache cache in CacheManager.GetAllCaches()) {
				cache.Clear();
			}
			UpdateTotals();
		}

		protected void rptSCProfiles_DataBound(object sender, RepeaterItemEventArgs e) {
			Repeater rptBySite = (Repeater)e.Item.FindControl("rptBySite");
			Cache cacheItem = (Cache)e.Item.DataItem;
			if (rptBySite != null) {
				rptBySite.DataSource = cacheItem.GetCacheKeys();
				rptBySite.DataBind();
			}
		}

		/// <summary>
		/// Sites
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void FetchSiteCacheProfile(object sender, EventArgs e) {

			rptSiteCacheProfiles.DataSource = GetCachesByNames(GetSelectedSiteNames());
			rptSiteCacheProfiles.DataBind();
		}

		protected void ClearSiteCacheProfile(object sender, EventArgs e) {

			List<Cache> list = GetCachesByNames(GetSelectedSiteNames());
			ClearCaches(list);
			rptSiteCaches.DataSource = list;
			rptSiteCaches.DataBind();
		}

		protected void FetchSiteCacheList(object sender, EventArgs e) {

			rptSiteCaches.DataSource = GetCachesByNames(GetSelectedSiteNames());
			rptSiteCaches.DataBind();
		}

		/// <summary>
		/// DB
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void FetchDBCacheProfile(object sender, EventArgs e) {

			rptDBCacheProfiles.DataSource = GetCachesByNames(GetSelectedDBNames());
			rptDBCacheProfiles.DataBind();
		}

		protected void ClearDBCacheProfile(object sender, EventArgs e) {

			List<Cache> list = GetCachesByNames(GetSelectedDBNames());
			ClearCaches(list);
			rptDBCaches.DataSource = list;
			rptDBCaches.DataBind();
		}

		protected void FetchDBCacheList(object sender, EventArgs e) {

			rptDBCaches.DataSource = GetCachesByNames(GetSelectedDBNames());
			rptDBCaches.DataBind();
		}

		/// <summary>
		/// Access Result
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void FetchARCacheProfile(object sender, EventArgs e) {

			rptARCacheProfiles.DataSource = GetCachesByNames(GetSelectedItemValues(cblAccessResult.Items));
			rptARCacheProfiles.DataBind();
		}

		protected void ClearARCacheProfile(object sender, EventArgs e) {

			List<Cache> list = GetCachesByNames(GetSelectedItemValues(cblAccessResult.Items));
			ClearCaches(list);
			rptARCaches.DataSource = list;
			rptARCaches.DataBind();
		}

		protected void FetchARCacheList(object sender, EventArgs e) {

			rptARCaches.DataSource = GetCachesByNames(GetSelectedItemValues(cblAccessResult.Items));
			rptARCaches.DataBind();
		}

		/// <summary>
		/// MISC
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void FetchMiscCacheProfile(object sender, EventArgs e) {

			rptMiscCacheProfiles.DataSource = GetCachesByNames(GetSelectedItemValues(cblMiscNames.Items));
			rptMiscCacheProfiles.DataBind();
		}

		protected void ClearMiscCacheProfile(object sender, EventArgs e) {

			List<Cache> list = GetCachesByNames(GetSelectedItemValues(cblMiscNames.Items));
			ClearCaches(list);
			rptMiscCaches.DataSource = list;
			rptMiscCaches.DataBind();
		}

		protected void FetchMiscCacheList(object sender, EventArgs e) {

			rptMiscCaches.DataSource = GetCachesByNames(GetSelectedItemValues(cblMiscNames.Items));
			rptMiscCaches.DataBind();
		}

		/// <summary>
		/// Global Query
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnGQuery_Click(object sender, EventArgs e) {
			List<ListItem> qr = new List<ListItem>();
			IEnumerable<Cache> allCaches = CacheManager.GetAllCaches().OrderBy(a => a.Name);

			string query = txtGQuery.Text.ToLower();
			foreach (Cache c in allCaches) {
				try {
					foreach (string s in c.GetCacheKeys()) {
						if (s.ToLower().Contains(query)) {
							qr.Add(new ListItem(c.Name, s));
						}
					}
				} catch (Exception ex) {
					//Sitecore.Caching.AccessResultCacheKey is private and blows up
				}
			}
			rptGQuery.DataSource = qr;
			rptGQuery.DataBind();
			ltlResults.Text = qr.Count.ToString() + " Results";
		}

		protected void btnGQueryClear_Click(object sender, EventArgs e) {
			List<ListItem> qr = new List<ListItem>();
			IEnumerable<Cache> allCaches = CacheManager.GetAllCaches().OrderBy(a => a.Name);

			string query = txtGQuery.Text.ToLower();
			foreach (Cache c in allCaches) {
				try {
					foreach (string s in c.GetCacheKeys()) {
						if (s.ToLower().Contains(query)) {
							c.Remove(s);
						}
					}
				} catch (Exception ex) {
					//Sitecore.Caching.AccessResultCacheKey is private and blows up
				}
			}
			rptGQuery.DataSource = qr;
			rptGQuery.DataBind();
			ltlResults.Text = qr.Count.ToString() + " Results";
		}

		//Helpers
		protected void ClearCaches(List<Cache> caches) {
			foreach (Cache c in caches) {
				c.Clear();
			}
		}

		protected List<string> GetSelectedSiteNames() {

			List<string> returnNames = new List<string>();

			//get selected types
			List<string> siteTypesSelected = new List<string>();
			foreach (ListItem li in cblSiteTypes.Items) {
				if (li.Selected) {
					siteTypesSelected.Add(li.Value);
				}
			}

			//get selected sites caches
			List<Cache> allCaches = new List<Cache>();
			List<string> list = GetSelectedItemValues(cblSiteNames.Items);
			list.AddRange(GetSelectedItemValues(cblSysSiteNames.Items));
			foreach (string li in list) {
				foreach (string s in siteTypesSelected) {
					returnNames.Add(li + s);
				}
			}

			return returnNames;
		}

		protected List<string> GetSelectedDBNames() {

			List<string> returnNames = new List<string>();

			//get selected types
			List<string> siteTypesSelected = new List<string>();
			foreach (ListItem li in cblDBTypes.Items) {
				if (li.Selected) {
					siteTypesSelected.Add(li.Value);
				}
			}

			//get selected sites caches
			List<Cache> allCaches = new List<Cache>();
			List<string> list = GetSelectedItemValues(cblDBNames.Items);
			foreach (string li in list) {
				foreach (string s in siteTypesSelected) {
					returnNames.Add(li + s);
				}
			}

			return returnNames;
		}

		protected List<Cache> GetCachesByNames(List<string> names) {

			List<Cache> returnCaches = new List<Cache>();
			foreach (string s in names) {
				Cache c = CacheManager.FindCacheByName(s);
				if (c != null) {
					returnCaches.Add(c);
				}
			}
			return returnCaches;
		}

		protected List<string> GetSelectedItemValues(ListItemCollection lic) {
			List<string> lil = new List<string>();
			foreach (ListItem li in lic) {
				if (li.Selected) {
					lil.Add(li.Value);
				}
			}
			return lil;
		}

		protected string GetValFromB(long l) {
			long mb = 1048576;
			long kb = 1024;
			if (l > mb) {
				return (l / mb).ToString() + "MB";
			} else if (l > kb) {
				return (l / kb).ToString() + "KB";
			}
			return l.ToString() + "B";
		}

		private void UpdateTotals() {
			CacheStatistics statistics = CacheManager.GetStatistics();
			ltlEntries.Text = statistics.TotalCount.ToString();
			ltlSize.Text = GetValFromB(statistics.TotalSize);
		}

		protected string GetClass(int ItemIndex) {
			return ((ItemIndex % 2).Equals(0)) ? "even" : "odd";
		}
	}

}