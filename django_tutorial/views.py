from django.views import generic

class WelcomeView(generic.TemplateView):
    template_name = 'welcome.html'
