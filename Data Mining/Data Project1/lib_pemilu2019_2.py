def get_response(requests, url, sleep, random):
    print(url)
    for i in range(100):
        try:
            response = requests.request("GET", url).json()
            return response
        except:
            pass
        sleep(random.randint(3,6))
    


def get_data(
                    nama_kab,
                    key_kab,
                    nama_kec,
                    key_kec,
                    nama_kel,
                    key_kel,
                    nama_tps,
                    key_tps
                ):
    
    return(
                    nama_kab,
                    key_kab,
                    nama_kec,
                    key_kec,
                    nama_kel,
                    key_kel,
                    nama_tps,
                    key_tps
                )


    # print(f'Jumlah Pemilih = ' + str(jumlah_pemilih))
    # print(f'Suara Sah = '+ str(suara_sah) )
    # print(f'Jumlah pengguna = ' + str(jumlah_pengguna))
    # print(f'Suara Total = ' + str(suara_total))
    # print(f'Suara tidak sah = ' + str(suara_tidak_sah))
    # print(f'Pemilih Jokowo-Maruf = ' + str(pemilih_jokowi))
    # print(f'Pemilih Prabowo-Snadiaga = ' + str(pemilih_prabowo))

def get_unique_number(res):
    dt = []
    for key in res:
        key = key
        nm = res[key]['nama']
        dt.append(
            (key, nm)
        )
    return dt

def get_catatframe(pd, data):
    return pd.DataFrame(data, columns=[
        "nama_kab",
        "key_kab",
        "nama_kec",
        "key_kec",
        "nama_kel",
        "key_kel",
        "nama_tps",
        "key_tps"
        ])


def save_to_xlsx(df):
    df.to_excel('daftar_prov_SUMATERA BARAT.xlsx', index=False)
    print('Data Saved to Local Disk')


