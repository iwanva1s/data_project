import requests
import pandas as pd
import lib_pemilu2019_2 as lp
from time import sleep
import random

url_main = 'https://pemilu2019.kpu.go.id/static/json/wilayah/12920.json'
res = lp.get_response(requests, url_main, sleep, random)
unique_KAB = lp.get_unique_number(res)

data = []

# KABUPATEN DI TIAP PROVINSI
for kec in range(0, len(unique_KAB)):
        # for kec in range(0, 1):
    key_kab = unique_KAB[kec][0]
    nama_kab = unique_KAB[kec][1]
                    
    url_kel = f'https://pemilu2019.kpu.go.id/static/json/wilayah/12920/{key_kab}.json'
    res = lp.get_response(requests, url_kel, sleep, random)
    unique_kec = lp.get_unique_number(res)

    # KECAMATAN DI TIAP KABUPATEN
    for kec in range(0, len(unique_kec)):
        # for kec in range(0, 1):
        key_kec = unique_kec[kec][0]
        nama_kec = unique_kec[kec][1]
                    
        url_kel = f'https://pemilu2019.kpu.go.id/static/json/wilayah/12920/{key_kab}/{key_kec}.json'
        res = lp.get_response(requests, url_kel, sleep, random)
        unique_kel = lp.get_unique_number(res)

            # KELURAHAN DI TIAP KECAMATAN
        for kec in range(0, len(unique_kel)):
            # for kec in range(0, 1):
            key_kel = unique_kel[kec][0]
            nama_kel = unique_kel[kec][1]
                    
            url_kel = f'https://pemilu2019.kpu.go.id/static/json/wilayah/12920/{key_kab}/{key_kec}/{key_kel}.json'
            res = lp.get_response(requests, url_kel, sleep, random)
            unique_tps = lp.get_unique_number(res)

            for kec in range(0, len(unique_tps)):
                key_tps = unique_tps[kec][0]
                nama_tps = unique_tps[kec][1]

                print(key_tps)
                print(nama_tps)

                url_kel = f'https://pemilu2019.kpu.go.id/static/json/hhcw/ppwp/12920/{key_kab}/{key_kec}/{key_kel}.json'
                res = lp.get_response(requests, url_kel, sleep, random)
                # unique_tps = lp.get_unique_number(res)

                data_pemilu = lp.get_data(nama_kab, key_kab, nama_kec, key_kec, nama_kel, key_kel, nama_tps, key_tps)
                data.append(data_pemilu)

df = lp.get_catatframe(pd,data)
lp.save_to_xlsx(df)
print(df)


