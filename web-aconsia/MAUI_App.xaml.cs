namespace ACONSIA;

public partial class App : Application
{
    public App()
    {
        InitializeComponent();

        // Initialize storage service
        var storageService = new Services.StorageService();
        storageService.InitializeDemoData();

        // Set main page to Landing Page
        MainPage = new NavigationPage(new Views.LandingPage())
        {
            BarBackgroundColor = Colors.White,
            BarTextColor = Color.FromArgb("#0F172A")
        };
    }
}
