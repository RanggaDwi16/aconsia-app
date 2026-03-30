using Microsoft.Extensions.Logging;

namespace ACONSIA;

public static class MauiProgram
{
    public static MauiApp CreateMauiApp()
    {
        var builder = MauiApp.CreateBuilder();
        
        builder
            .UseMauiApp<App>()
            .ConfigureFonts(fonts =>
            {
                fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
                fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
            });

        // Register Services
        builder.Services.AddSingleton<Services.StorageService>();

        // Register ViewModels
        builder.Services.AddTransient<ViewModels.LandingViewModel>();
        builder.Services.AddTransient<ViewModels.PatientLoginViewModel>();
        builder.Services.AddTransient<ViewModels.DoctorLoginViewModel>();
        builder.Services.AddTransient<ViewModels.PatientDashboardViewModel>();
        builder.Services.AddTransient<ViewModels.DoctorDashboardViewModel>();

        // Register Views
        builder.Services.AddTransient<Views.LandingPage>();
        builder.Services.AddTransient<Views.PatientLoginPage>();
        builder.Services.AddTransient<Views.DoctorLoginPage>();
        builder.Services.AddTransient<Views.PatientDashboardPage>();
        builder.Services.AddTransient<Views.DoctorDashboardPage>();

#if DEBUG
        builder.Logging.AddDebug();
#endif

        return builder.Build();
    }
}
