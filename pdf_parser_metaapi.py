def get_pdf_text(pdf_id: str, phone_id: str) -> str:

    """Access whatsapp document media by sending get request using pdf id, retrieve pdf url,
      and send second get request with pdf url to whatsapp server to obtain Binary file. Parse
      the returned binary file using PyPDF2 Reader, and return only text parsed in document as
      single string"""

    # Construct the URL to fetch the media info
    url = f'https://graph.facebook.com/v12.0/{pdf_id}'

    # Set headers for authorizationm - GRAPH_API_TOKEN refers to the access token to enter whatsapp/meta api and request information
    headers = {
        'Authorization': f'Bearer {GRAPH_API_TOKEN}'
    }

    # Fetch the media file information, which contains the pdf url
    response = requests.get(url, headers=headers)

    if response.status_code == 200: #if the post request is successfulm then extract the information about the pdf
        media_info = response.json()
        pdf_url = media_info.get('url') #store pdf url to access pdf id

        if response.status_code == 200:
            media_info = response.json()
            pdf_url = media_info.get('url')

            # accessing the binary file representing the pdf using a post request with pdf url argument
            pdf_response = requests.get(pdf_url, headers=headers)

            if pdf_response.status_code == 200:
                # Parse the PDF content using the PdfReader library
                pdf_file = io.BytesIO(pdf_response.content)  # Create a BytesIO object from the binary content
                pdf_reader = PdfReader(pdf_file)
                pdf_text = ""

                # Extract text from each page and store in string variable, returning parsed text, and ignoring any images
                for page in pdf_reader.pages:
                    if page.extract_text():  # Check if the page has text
                        pdf_text += page.extract_text() + "\n"

                return pdf_text
