

CREATE TABLE add_contacts_apply (
        user_id STRING NOT NULL,
        contacts_id STRING NOT NULL,
        message STRING NOT NULL,
		update_time TIMESTAMPTZ NOT NULL DEFAULT now(),
        CONSTRAINT "primary" PRIMARY KEY (contacts_id, user_id)
);