from django.db import models

class AnnounceMent(models.Model):
    major = models.CharField(max_length=15)
    nid = models.CharField(max_length=10)
    title = models.CharField(max_length=500)
    url = models.CharField(max_length=1000)
    date_post = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'elec_general'

